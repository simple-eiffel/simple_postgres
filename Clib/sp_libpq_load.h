/* simple_postgres: find and load the PostgreSQL client library (libpq) on Windows.

   libpq.dll and the DLLs it needs (libssl, libcrypto, libintl, libiconv, zlib) are owned by
   the PostgreSQL installation: one source, one owner, nothing copied beside a program. The
   library is linked with /DELAYLOAD:libpq.dll, so a program starts even when PostgreSQL's bin
   folder is not on PATH, and libpq is loaded from its owner's folder here:
     1. %POSTGRESQL_HOME%\bin\libpq.dll;
     2. the PostgreSQL installer's registry entry
        (HKLM\SOFTWARE\PostgreSQL\Installations\<id>\Base Directory, then \bin);
     3. libpq.dll on the ordinary DLL search path.
   A full path is loaded with LOAD_WITH_ALTERED_SEARCH_PATH, so its own dependencies resolve
   from the same folder, not from whatever copies come first on PATH.
   The delay-load hook sends the linker's first libpq call through the same loader.
   Off Windows, libpq is linked normally, and the client is always there. */
#ifndef SP_LIBPQ_LOAD_H
#define SP_LIBPQ_LOAD_H

#ifdef _WIN32
#include <windows.h>
#include <delayimp.h>
#include <wchar.h>

/* The folder libpq.dll was loaded from, for the error text; empty until loaded. */
__declspec(selectany) wchar_t sp_libpq_loaded_from[MAX_PATH] = L"";

static HMODULE sp_libpq_try_folder(const wchar_t *a_bin) {
    wchar_t l_path[MAX_PATH];
    HMODULE l_module;
    if (!a_bin || !a_bin[0]) return NULL;
    if (_snwprintf(l_path, MAX_PATH, L"%ls\\libpq.dll", a_bin) < 0) return NULL;
    l_path[MAX_PATH - 1] = 0;
    if (GetFileAttributesW(l_path) == INVALID_FILE_ATTRIBUTES) return NULL;
    l_module = LoadLibraryExW(l_path, NULL, LOAD_WITH_ALTERED_SEARCH_PATH);
    if (l_module) wcsncpy(sp_libpq_loaded_from, a_bin, MAX_PATH - 1);
    return l_module;
}

/* The bin folder of the first PostgreSQL the installer registered, or empty. */
static int sp_libpq_registry_bin(wchar_t *a_bin, DWORD a_size) {
    HKEY l_root, l_install;
    wchar_t l_name[256], l_base[MAX_PATH];
    DWORD l_name_size = 256, l_base_size = sizeof(l_base), l_type = 0;
    int l_found = 0;
    if (RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\PostgreSQL\\Installations", 0, KEY_READ, &l_root) != ERROR_SUCCESS) return 0;
    if (RegEnumKeyExW(l_root, 0, l_name, &l_name_size, NULL, NULL, NULL, NULL) == ERROR_SUCCESS
        && RegOpenKeyExW(l_root, l_name, 0, KEY_READ, &l_install) == ERROR_SUCCESS) {
        if (RegQueryValueExW(l_install, L"Base Directory", NULL, &l_type, (LPBYTE) l_base, &l_base_size) == ERROR_SUCCESS
            && l_type == REG_SZ) {
            l_base[MAX_PATH - 1] = 0;
            if (_snwprintf(a_bin, a_size, L"%ls\\bin", l_base) >= 0) { a_bin[a_size - 1] = 0; l_found = 1; }
        }
        RegCloseKey(l_install);
    }
    RegCloseKey(l_root);
    return l_found;
}

/* libpq, loaded from its owner's folder; NULL when no PostgreSQL client is installed. */
static HMODULE sp_libpq_module(void) {
    HMODULE l_module = GetModuleHandleW(L"libpq.dll");
    wchar_t l_bin[MAX_PATH];
    DWORD l_length;
    if (l_module) return l_module;
    l_length = GetEnvironmentVariableW(L"POSTGRESQL_HOME", l_bin, MAX_PATH - 5);
    if (l_length > 0 && l_length < MAX_PATH - 5) {
        wcscat(l_bin, L"\\bin");
        if ((l_module = sp_libpq_try_folder(l_bin))) return l_module;
    }
    if (sp_libpq_registry_bin(l_bin, MAX_PATH) && (l_module = sp_libpq_try_folder(l_bin))) return l_module;
    l_module = LoadLibraryW(L"libpq.dll");
    if (l_module) wcsncpy(sp_libpq_loaded_from, L"(the DLL search path)", MAX_PATH - 1);
    return l_module;
}

/* The delay-load hook: the linker's first libpq call loads through sp_libpq_module. */
static FARPROC WINAPI sp_libpq_hook(unsigned a_notify, PDelayLoadInfo a_info) {
    if (a_notify == dliNotePreLoadLibrary && a_info && a_info->szDll && _stricmp(a_info->szDll, "libpq.dll") == 0)
        return (FARPROC) sp_libpq_module();
    return NULL;
}
__declspec(selectany) const PfnDliHook __pfnDliNotifyHook2 = sp_libpq_hook;

static int sp_libpq_available(void) { return sp_libpq_module() != NULL; }
#else
static int sp_libpq_available(void) { return 1; }
#endif

#endif

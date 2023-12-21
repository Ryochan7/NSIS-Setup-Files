// ConsoleApplication2.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <Windows.h>

#define MAX_KEY_LENGHT 255
#define MAX_VALUE_NAME 16383

bool checkNETVersion()
{
    bool result = false;
    DWORD dwRet = 0;
    LONG retCode = 0;
    DWORD dwBufferSize(sizeof(DWORD));
    HKEY hKey;
    DWORD nSubKeys = 0;
    DWORD nValues = 0;
    LONG lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE,
        L"SOFTWARE\\WOW6432Node\\dotnet\\Setup\\InstalledVersions\\x64\\sharedfx\\Microsoft.WindowsDesktop.App",
        0, KEY_READ, &hKey);

    if (lRes == ERROR_SUCCESS)
    {
        lRes = RegQueryInfoKey(hKey, NULL, NULL, NULL, NULL, NULL, NULL, &nValues, NULL, NULL, NULL, NULL);
        if (lRes == ERROR_SUCCESS)
        {
            TCHAR* achValue = new TCHAR[MAX_VALUE_NAME];
            DWORD cchValue = MAX_VALUE_NAME;

            for (int i = 0; i < nValues; i++)
            {
                memset(achValue, 0, sizeof(TCHAR) * MAX_VALUE_NAME);
                cchValue = MAX_VALUE_NAME;

                retCode = RegEnumValue(hKey, i, achValue, &cchValue, NULL, NULL, NULL, NULL);
                if (retCode == ERROR_SUCCESS)
                {
                    dwRet = 0;
                    LONG nError = RegQueryValueExW(hKey, achValue, 0, NULL, reinterpret_cast<LPBYTE>(&dwRet), &dwBufferSize);
                    std::wstring strtmp(&achValue[0], &achValue[MAX_VALUE_NAME]);
                    //size_t testPos = strtmp.find(L"6.", 0);
                    if (nError == ERROR_SUCCESS && strtmp.find(L"8.", 0) != std::string::npos)
                    {
                        result = true;
                        break;
                    }
                }
            }

            delete[] achValue;
        }

        RegCloseKey(hKey);
    }

    return result;
}

int main()
{
    int returnCode = 0;

    std::cout << "Hello World!\n";
    bool netFound = checkNETVersion();
    if (!netFound)
    {
        returnCode = EXIT_FAILURE;
    }

    return returnCode;
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file

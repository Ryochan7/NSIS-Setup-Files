// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>

#include <Windows.h>
#include <initguid.h>
#include <newdev.h>
#include <devguid.h>
#include <devpkey.h>

using namespace std;

string FakerInputHardwareID("root\\FakerInput");
string FakerInputName("FakerInput");
//string ViGEmBusHardwareID("Nefarius/ViGEmBus/Gen1");
string ViGEmBusName("ViGEmBus");
string HidHideName("HidHide");
string HidHideHardwareId("root\\HidHide");
wstring ViGEmBusGUID = (L"{96E42B22-F5E9-42F8-B043-ED0F932F014F}");


wstring obtainSysDeviceInstanceId(GUID classGUID, wstring searchHardwareId)
{
    wstring result(L"");
    SP_DEVINFO_DATA deviceInfoData;
    deviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
    HDEVINFO hinfo = SetupDiGetClassDevs(&classGUID, NULL, NULL, 0);
    if (hinfo == INVALID_HANDLE_VALUE)
    {
        //error(GetLastError());
        //return 1;
        return result;
    }

    int ix = 0;
    while (SetupDiEnumDeviceInfo(hinfo, ix++, &deviceInfoData))
    {
        DEVPROPTYPE proptype;
        DWORD requiredSize;
        bool tempResult = SetupDiGetDeviceProperty(hinfo, &deviceInfoData, &DEVPKEY_Device_InstanceId,
            &proptype, NULL, 0, &requiredSize, 0);
        if (requiredSize > 0)
        {
            DWORD bufferSize = requiredSize;
            PBYTE buf = new BYTE[bufferSize];
            SetupDiGetDeviceProperty(hinfo, &deviceInfoData, &DEVPKEY_Device_InstanceId,
                &proptype, buf, bufferSize, NULL, 0);
            PWCHAR punk = (PWCHAR)buf;
            std::wstring puckAssBitches = std::wstring(punk);
            wcout << puckAssBitches << endl;
            delete[] buf;

            if (puckAssBitches._Equal(searchHardwareId))
            {
                cout << "Punk Ass Bitches" << endl;
                result = searchHardwareId;
                break;
            }
        }
    }

    SetupDiDestroyDeviceInfoList(hinfo);
    return result;
}

bool checkForDeviceByGUID(GUID classGuid)
{
    bool result = false;
    SP_DEVINFO_DATA deviceInfoData;
    deviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
    //GUID sysGuid = GUID_DEVCLASS_SYSTEM;
    HDEVINFO hinfo = SetupDiGetClassDevs(&classGuid, NULL, NULL, DIGCF_DEVICEINTERFACE);
    if (hinfo == INVALID_HANDLE_VALUE)
    {
        //error(GetLastError());
        //return 1;
        return false;
    }

    int ix = 0;
    if (SetupDiEnumDeviceInfo(hinfo, ix++, &deviceInfoData))
    {
        result = true;
    }

    SetupDiDestroyDeviceInfoList(hinfo);
    return result;
}

bool checkForDevice(GUID classGuid, wstring searchHardwareId)
{
    bool result = false;
    SP_DEVINFO_DATA deviceInfoData;
    deviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
    //GUID sysGuid = GUID_DEVCLASS_SYSTEM;
    HDEVINFO hinfo = SetupDiGetClassDevs(&classGuid, NULL, NULL, 0);
    if (hinfo == INVALID_HANDLE_VALUE)
    {
        //error(GetLastError());
        //return 1;
        return false;
    }

    int ix = 0;
    while (SetupDiEnumDeviceInfo(hinfo, ix++, &deviceInfoData))
    {
        DEVPROPTYPE proptype;
        DWORD requiredSize;
        bool tempResult = SetupDiGetDeviceProperty(hinfo, &deviceInfoData, &DEVPKEY_Device_HardwareIds,
            &proptype, NULL, 0, &requiredSize, 0);
        if (requiredSize > 0)
        {
            DWORD bufferSize = requiredSize;
            PBYTE buf = new BYTE[bufferSize];
            SetupDiGetDeviceProperty(hinfo, &deviceInfoData, &DEVPKEY_Device_HardwareIds,
                &proptype, buf, bufferSize, NULL, 0);
            PWCHAR punk = (PWCHAR)buf;
            std::wstring puckAssBitches = std::wstring(punk);
            wcout << puckAssBitches << endl;
            delete[] buf;

            if (puckAssBitches._Equal(searchHardwareId))
            {
                cout << "Punk Ass Bitches" << endl;
                wprintf(L"Match\n");
                result = true;
                break;
            }
        }
    }

    SetupDiDestroyDeviceInfoList(hinfo);
    return result;
}


int commandFind(int argc, char** argv)
{
    if (argc != 3)
    {
        return EXIT_FAILURE;
    }

    std::string package(argv[2]);
    if (package._Equal(FakerInputName))
    {
        string hardwareId = FakerInputHardwareID;
        wstring searchHardwareId(hardwareId.begin(), hardwareId.end());
        if (!checkForDevice(GUID_DEVCLASS_SYSTEM, searchHardwareId))
        {
            return 2;
        }
    }
    else if (package._Equal(ViGEmBusName))
    {
        GUID guid;
        HRESULT temp = CLSIDFromString(ViGEmBusGUID.c_str(), (LPCLSID)&guid);
        if (!checkForDeviceByGUID(guid))
        {
            return 2;
        }
    }
    else if (package._Equal(HidHideName))
    {
        string hardwareId = HidHideHardwareId;
        wstring searchHardwareId(hardwareId.begin(), hardwareId.end());
        if (!checkForDevice(GUID_DEVCLASS_SYSTEM, searchHardwareId))
        {
            return 2;
        }
    }
    else
    {
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}


int main(int argc, char** argv)
{
    int result = 0;

    cout << "Hello World!\n";

    /*shitter2();
    shitter3();*/

    std::string command(argv[1]);

    if (command._Equal("find"))
    {
        result = commandFind(argc, argv);
    }
    else
    {
        result = EXIT_FAILURE;
    }

    return result;
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

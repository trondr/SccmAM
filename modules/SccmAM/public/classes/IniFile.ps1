$code = @"
        //Source: https://stackoverflow.com/questions/217902/reading-writing-an-ini-file
        using System.IO;
        using System.Reflection;
        using System.Runtime.InteropServices;
        using System.Text;
        
        // Change this to match your program's normal namespace
        namespace SccmAM
        {
            public static class IniFile   // revision 11
            {
                [DllImport("kernel32", CharSet = CharSet.Unicode)]
                static extern long WritePrivateProfileString(string section, string key, string value, string filePath);
        
                [DllImport("kernel32", CharSet = CharSet.Unicode)]
                static extern int GetPrivateProfileString(string section, string Key, string defaultValue, StringBuilder retVal, int size, string filePath);
        
                public static string Read(string path, string section, string key)
                {
                    var value = new StringBuilder(255);
                    GetPrivateProfileString(section, key, "", value, 255, path);
                    return value.ToString();
                }
        
                public static void Write(string path, string section, string key, string value)
                {
                    WritePrivateProfileString(section, key, value, path);
                }
        
                public static void DeleteKey(string path,string key, string section)
                {
                    Write(path, key, null, section);
                }
        
                public static void DeleteSection(string path, string section)
                {
                    Write(path,null, null, section);
                }
        
                public static bool KeyExists(string path, string key, string section)
                {
                    return Read(path, section, key).Length > 0;
                }
            }
        }
"@
if (-not ([System.Management.Automation.PSTypeName]'SccmAM.IniFile').Type)
{
    Add-Type -TypeDefinition $code -Language CSharp
}
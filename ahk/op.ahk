#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%

; Read the credential
if (cred := CredRead("1Pass")) {
    password := cred.password
} 

Run, 1Password.exe
WinWaitActive, 1Password

Send %password%
Send, {Enter}

WinClose, ahk_exe 1Password.exe

Click
return

CredRead(name)
{
    DllCall("Advapi32.dll\CredReadW"
    , "Str", name
    , "UInt", 1
    , "UInt", 0
    , "Ptr*", pCred
    , "UInt") 
    if !pCred
        return
    name := StrGet(NumGet(pCred + 8 + A_PtrSize * 0, "UPtr"), 256, "UTF-16")
    username := StrGet(NumGet(pCred + 24 + A_PtrSize * 6, "UPtr"), 256, "UTF-16")
    len := NumGet(pCred + 16 + A_PtrSize * 2, "UInt")
    password := StrGet(NumGet(pCred + 16 + A_PtrSize * 3, "UPtr"), len/2, "UTF-16")
    DllCall("Advapi32.dll\CredFree", "Ptr", pCred)
    return {"name": name, "username": username, "password": password}
}

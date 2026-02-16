codeunit 78152 "ATC_CAV_SingleIstance"
{
    Access = Internal;
    SingleInstance = true;

    var
        IsAllowed: Boolean;

    procedure setAllowed(pAllowed: Boolean)
    begin
        IsAllowed := pAllowed;
    end;

    procedure getAllowed(): Boolean
    begin
        exit(IsAllowed);
    end;

}

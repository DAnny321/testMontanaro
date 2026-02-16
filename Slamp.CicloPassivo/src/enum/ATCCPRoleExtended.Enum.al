enum 90207 "ATC_CP_RoleExtended"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; Requester)
    {
        Caption = 'Requester', comment = 'ITA="Richiedente"';
    }
    value(2; "Division Owner")
    {
        Caption = 'Division Owner', comment = 'ITA="Proprietario divisione"';
    }
    value(3; Administration)
    {
        Caption = 'Administration', comment = 'ITA="Amministrazione"';
    }
    value(4; "Purchase Office")
    {
        Caption = 'Purchase Office', comment = 'ITA="Ufficio acquisti"';
    }
}
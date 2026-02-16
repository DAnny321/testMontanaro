enum 90203 "ATC_CP_Recover Mail From"
{
    Extensible = true;

    value(0; UserSetup)
    {
        Caption = 'User Setup', comment = 'ITA="Setup utente"';
    }

    value(1; GroupMail)
    {
        Caption = 'Group Mail', comment = 'ITA="Mail gruppo"';
    }
    value(2; GenericMail)
    {
        Caption = 'Generic Mail', comment = 'ITA="Mail generica"';
    }

}
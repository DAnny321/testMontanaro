enum 90205 "ATC_CP_Priority"
{
    Extensible = true;

    value(0; Low)
    {
        Caption = 'Low', comment = 'ITA="Bassa"';
    }
    value(1; "Middle")
    {
        Caption = 'Middle', comment = 'ITA="Media"';
    }
    value(2; High)
    {
        Caption = 'High', comment = 'ITA="Alta"';
    }
    value(3; Maxim)
    {
        Caption = 'Maxim', comment = 'ITA="Massima"';
    }

}
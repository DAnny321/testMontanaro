enum 90200 "ATC_CP_Vendor Rating"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; R1)
    {
        Caption = '1 - Lower', comment = 'ITA="1 - Minimo"';
    }
    value(2; R2)
    {
        Caption = '2 - Low', comment = 'ITA="2 - Basso"';
    }
    value(3; R3)
    {
        Caption = '3 - Sufficient', comment = 'ITA="3 - Sufficiente"';
    }
    value(4; R4)
    {
        Caption = '4 - Good', comment = 'ITA="4 - Buono"';
    }
    value(5; R5)
    {
        Caption = '5 - Excellent', comment = 'ITA="5 - Ottimo"';
    }
}
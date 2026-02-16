enum 90210 "ATC_CP_Line Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; "G/L Account")
    {
        Caption = 'G/L Account', comment = 'ITA="Conto C/G"';
    }
    value(2; Item)
    {
        Caption = 'Item', comment = 'ITA="Articolo"';
    }
    value(4; "Fixed Asset")
    {
        Caption = 'Fixed Asset', comment = 'ITA="Cespite"';
    }
    value(5; "Charge (Item)")
    {
        Caption = 'Charge (Item)', comment = 'ITA="Addebito (Articolo)"';
    }
}
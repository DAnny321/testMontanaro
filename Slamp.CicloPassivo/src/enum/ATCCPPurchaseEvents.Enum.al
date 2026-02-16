enum 90201 "ATC_CP_Purchase Events"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; RequestRelease)
    {
        Caption = 'Request Release', comment = 'ITA="Rilascio richiesta"';
    }
    value(2; OrderCreation)
    {
        Caption = 'Order Creation', comment = 'ITA="Creazione ordine"';
    }
    value(3; RequestReceiptPost)
    {
        Caption = 'Request Receipt Post', comment = 'ITA="Richiedi registrazione carico"';
    }
    value(4; ReleaseOrder)
    {
        Caption = 'Order Release', comment = 'ITA="Rilascio ordine"';
    }
}
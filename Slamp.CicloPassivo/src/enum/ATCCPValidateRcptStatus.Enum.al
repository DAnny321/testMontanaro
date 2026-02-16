enum 90212 "ATC_CP_ValidateRcptStatus"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; Processable)
    {
        Caption = 'Post Receipt', comment = 'ITA="Registra carico"';
    }
    value(2; PostingError)
    {
        Caption = 'Receipt Posting Error', comment = 'ITA="Errore registrazione carico"';
    }
    value(3; "ReceiptPosted")
    {
        Caption = 'Receipt Posted', comment = 'ITA="Carico registrato"';
    }

}
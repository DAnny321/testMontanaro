enum 90202 "ATC_CP_Notify Mail As"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ITA=" "';
    }
    value(1; A)
    {
        Caption = 'To:', comment = 'ITA="A:"';
    }
    value(2; CC)
    {
        Caption = 'CC:', comment = 'ITA="CC:"';
    }

    value(3; BCC)
    {
        Caption = 'BCC:', comment = 'ITA="CCN:"';
    }
}
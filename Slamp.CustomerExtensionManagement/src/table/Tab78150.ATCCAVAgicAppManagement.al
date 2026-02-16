table 78150 "ATC_CAV_AgicAppManagement"
{
    Caption = 'Agic Extension anagement', comment = 'ITA="Gestione Extension Agic"';
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    Access = Internal;

    fields
    {

        field(2; ATC_CAV_AppID; Enum ATC_SC_ExtensionAgic)
        {
            Caption = 'App ID', comment = 'ITA="App ID"';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; ATC_CAV_AppModuleId; Text[50])
        {
            Caption = 'App Module', comment = 'ITA="Modulo app"';
            DataClassification = ToBeClassified;
        }
        field(4; ATC_CAV_AppValidityDueDate; Date)
        {
            Caption = 'App Validity Due Date', comment = 'ITA="Data scadenza validità app"';
            DataClassification = ToBeClassified;
        }
        field(5; ATC_CAV_AppName; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; ATC_CAV_ModuleName; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; ATC_CAV_LastCheckDate; Date)
        {
            Caption = 'Last Check Date', comment = 'ITA="Data ultimo controllo"';
            DataClassification = ToBeClassified;
        }
        field(8; ATC_CAV_ExceptionsCounter; Integer)
        {
            Caption = 'Counter exceptions allowed', comment = 'ITA="Contatore eccezioni permesse"';
            DataClassification = ToBeClassified;
        }
        field(9; ATC_CAV_TrialUsed; Boolean)
        {
            Caption = 'Trial Used', comment = 'ITA="Periodo Trail usato"';
            DataClassification = ToBeClassified;
        }
        field(10; ATC_CAV_TrialExpirationDT; Date)
        {
            Caption = 'Trial Expiration Date', comment = 'ITA="Data fine periodo trial"';
            DataClassification = ToBeClassified;
        }
        field(11; ATC_CAV_LastExceptionDate; Date)
        {
            Caption = 'Last Exception Date', comment = 'ITA="Data ultima eccezione"';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; ATC_CAV_AppID, ATC_CAV_AppModuleId)
        {
            Clustered = true;
        }
    }

}

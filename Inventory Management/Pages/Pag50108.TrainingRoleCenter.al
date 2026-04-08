page 50108 "Training Role Center"

{
    ApplicationArea = All;
    Caption = 'Leave Manager RC';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {

        }
    }
    actions
    {
        area(Sections)
        {
                       
            group(Prourement)
            {
                action(Purchase)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase';
                    Image = List;
                    RunObject = page "Purchase Requisition List";
                }
            }


            group(Stores)
            {
                action(Drugs)
                {
                    ApplicationArea = All;
                    Caption = 'Stores';
                    Image = List;
                    RunObject = page "Drug List";
                }
                action("Drug Types")
                {
                    ApplicationArea = All;
                    Caption = 'Drug Type';
                    Image = List;
                    RunObject = page "Drug Type List";
                }
                action("Open Requisitions")
                {
                    ApplicationArea = All;
                    Caption = 'Open Requisitions';
                    Image = List;
                    RunObject = page "Store Requisition List";
                }
                action("Drug ledger Entry")
                {
                    Caption = 'Drug ledger Entry';
                    ApplicationArea = All;
                    Image = List;
                    RunObject = page "Drug Ledger Entry List";
                }
            }
                       
        }

    }

}
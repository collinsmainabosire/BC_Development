page 50115 "External Post Buffer List"
{
    PageType = List;
    SourceTable = "External Post Buffer";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id) { }
                field(Title; Rec.Title) { }
                field(Body; Rec.Body) { }
                field(UserId; Rec.UserId) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TestAPI)
            {
                ApplicationArea = All;
                Caption = 'Test API';

                trigger OnAction()
                var
                    Service: Codeunit "External POST Service";
                begin
                    Service.SendData();
                end;
            }
        }
    }
}
namespace ERP.ERP;

using System.Automation;

codeunit 50120 "Inventory Approval Open"
{
     [EventSubscriber(ObjectType::Codeunit, Codeunit:: "Workflow Response Handling", 'OnOpenDocument', '',true,true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        SRN: Record "Store Requisition Header";
    begin
        case RecRef.Number of
            Database::"Store Requisition Header":
                begin
                    RecRef.SetTable(SRN);

                    Page.Run(Page::"Store Requisition Card", SRN);

                    Handled := true;
                end;
        end;
    end;
}

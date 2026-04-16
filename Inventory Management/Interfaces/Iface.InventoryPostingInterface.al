/// <summary>
/// Interface InventoryPostingInterface.
/// </summary>
interface InventoryPostingInterface
{
    procedure PreValidate(DocumentNo: Code[20])
    procedure Post(DocumentNo: Code[20]);
}

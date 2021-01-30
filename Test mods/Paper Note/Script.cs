using UnityEngine;

public class PaperNoteMod : MonoBehaviour
{
    public static void Main()
    {
        Modification mod = new Modification("Paper note", "Brick");
        mod.Data.CategoryName = "Props";
        mod.Data.Description = "Allows you to write a message and show it after activation.";
        mod.Data.Thumbnail = mod.LoadSprite("PaperNote.png");
		
        mod.Data.SpawnAction += (Instance) =>
		{
			Instance.AddComponent<PaperNoteBehaviour>();
			Instance.GetComponent<SpriteRenderer>().sprite = mod.LoadSprite("PaperNote.png");
			Instance.FixColliders();
        };
    }
}

public class PaperNoteBehaviour : MonoBehaviour
{
	public string content = "Message";
	
	void Awake()
	{
		GetComponent<PhysicalObject>().DefaultButtons.Add(new ContextMenuButton("Set content", () =>
		{
			DialogController.main.Show("Enter the content:", new DialogButton[]
			{
			  new DialogButton("OK", () =>
			  {
				content = DialogController.main.FieldString;
			  }),
			  new DialogButton("Cancel", () =>
			  {
			  })
			}, DialogController.DialogType.Text);
		}));
		
		GetComponent<PhysicalObject>().OnUse += Show;
	}
	
	void Show()
	{
		Notification.Controller.New(content, Notify.NotifyType.Message);
	}
}
using UnityEngine;

public class EmptyMod : MonoBehaviour
{
    public static void Main()
    {
        Modification Modification = new Modification("Empty item", "Brick"); //Set name and original item
        Modification.Item.CategoryName = "Props"; //Set category
        Modification.Item.Description = "Description"; //Set description
        Modification.Item.Thumbnail = Modification.LoadSprite("None.png"); //Set thumbnail
		
	//On spawn
        Modification.Item.SpawnAction += (Instance) =>
	{
		Debug.Log(Instance.name + " spawned!");
        };
    }
}

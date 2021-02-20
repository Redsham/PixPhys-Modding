using UnityEngine;

public class EmptyMod : MonoBehaviour
{
    public static void Main()
    {
        Modification Modification = new Modification("Empty item", "Brick"); //Set name and original item
        Modification.Data.CategoryName = "Props"; //Set category
        Modification.Data.Description = "Description"; //Set description
        Modification.Data.Thumbnail = Modification.LoadSprite("None.png"); //Set thumbnail
		
	//On spawn
        Modification.Data.SpawnAction += (Instance) =>
	{
		Debug.Log(Instance.name + " spawned!");
        };
    }
}

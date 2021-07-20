using UnityEngine;

public class RainbowBrickMod : MonoBehaviour
{
    public static void Main()
    {
        Modification Modification = new Modification("Rainbow brick", "Brick");
        Modification.Item.CategoryName = "Props";
        Modification.Item.Description = "It changes colors.";
        Modification.Item.Thumbnail = Modification.LoadSprite("None.png");
		
        Modification.Item.SpawnAction += (Instance) =>
	{
		Instance.AddComponent<RainbowBrick>();
        };
    }
}

public class RainbowBrick : MonoBehaviour
{
	SpriteRenderer sprite;
	
	void Awake()
	{
		sprite = GetComponent<SpriteRenderer>();
		InvokeRepeating("Change", 0, 0.5f);
	}
	
	void Change()
	{
		sprite.color = UnityEngine.Random.ColorHSV();
	}
}

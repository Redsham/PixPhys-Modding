using UnityEngine;

public class RainbowBrickMod : MonoBehaviour
{
    public static void Main()
    {
        Modification Modification = new Modification("Rainbow brick", "Brick");
        Modification.Data.CategoryName = "Props";
        Modification.Data.Description = "It changes colors.";
        Modification.Data.Thumbnail = Modification.LoadSprite("None.png");
		
        Modification.Data.SpawnAction += (Instance) =>
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

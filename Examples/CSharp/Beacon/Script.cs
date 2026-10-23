using Modifications;
using UnityEngine;

public static class ExampleBeaconMod
{
    public static void Main(Modification modification)
    {
        var item = Prop.Register(modification, "SmallMetalCube", "ExampleBeacon", "Example beacon",
            "A pulsing blue beacon. Use the context menu to toggle it.", modification.Resources.LoadSprite("Sprites/Icon.png"));
        item.onPropInitialized += instance => instance.AddComponent<ExampleBeacon>().Initialize(modification);
    }
}

public sealed class ExampleBeacon : MonoBehaviour
{
    [Save] public bool IsOn = true;
    private Modification owner;
    private SpriteRenderer spriteRenderer;
    public void Initialize(Modification modification)
    {
        owner = modification;
        spriteRenderer = GetComponent<SpriteRenderer>();
        var body = GetComponent<PhysicalObject>();
        if (body) body.ContextButtons.Add(new PhysicalObject.ContextButton("Toggle beacon", null, () => IsOn = !IsOn, false));
    }
    private void Update()
    {
        if (!spriteRenderer || owner == null || !owner.Active) return;
        float pulse = IsOn ? .5f + .5f * Mathf.Sin(Time.time * 3) : 0;
        spriteRenderer.color = Color.Lerp(new Color(.15f,.2f,.3f), new Color(.2f,.75f,1), pulse);
    }
}

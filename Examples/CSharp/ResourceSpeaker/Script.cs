using Modifications;
using UnityEngine;

public static class ExampleSpeakerMod
{
    public static void Main(Modification modification)
    {
        var item = Prop.Register(modification, "SmallMetalCube", "ExampleSpeaker", "Example speaker",
            "Choose Play chime in the context menu.", modification.Resources.LoadSprite("Sprites/Icon.png"));
        item.onPropInitialized += instance =>
        {
            var body = instance.GetComponent<PhysicalObject>();
            var source = instance.AddComponent<AudioSource>();
            source.playOnAwake = false;
            if (body) body.ContextButtons.Add(new PhysicalObject.ContextButton("Play chime", null, () =>
            {
                if (modification.Active) source.PlayOneShot(modification.Resources.LoadSound("Audio/Chime.wav"));
            }, false));
        };
    }
}

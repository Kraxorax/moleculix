using UnityEngine;

public class MouseNearGlow : MonoBehaviour {

	Vector2 lastMousePos = Vector2.one;

	void Update () {
		Plane p = new Plane(Vector3.up, Vector3.zero);

		Vector2 mousePos = Input.mousePosition;

		if(mousePos != lastMousePos)
        {
			lastMousePos = mousePos;
        }

		Ray ray = GetComponent<Camera>().ScreenPointToRay( mousePos );

		if ( p.Raycast(ray, out float enterDist)) {
			Vector3 worldMousePos = ray.GetPoint(enterDist);

			Shader.SetGlobalVector("_MousePos", worldMousePos);
		}
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jezgro : MonoBehaviour {

	public int atomNumber = 1;

	void Start () {
		float scale = computeScale(atomNumber);
		transform.localScale = new Vector3(scale, scale, scale);
	}

	private float computeScale(int n)
	{
		float resultScale = 1;

		for (float i = 1; i < n; i++)
		{
			resultScale += (1 / i);
		}

		return resultScale;
	}
	
	// Update is called once per frame
	void Update () {
		float scale = computeScale(atomNumber);
		transform.localScale = new Vector3(scale, scale, scale);
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Atom : MonoBehaviour {

	public int atomNumber = 1;

	private int valentElectorns = 0;

	Rigidbody body;

	// Use this for initialization
	void Start () {
		body = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {
		body.transform.Rotate(new Vector3(0, 0.1f, 0), Space.Self);
	}
}

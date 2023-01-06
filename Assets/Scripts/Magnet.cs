using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;
using Assets.Scripts;


public class Magnet : MonoBehaviour {

	public bool isPlus = true;
	public GameObject bro;

	float charge;

	Magnet[] sviMagneti;
	Rigidbody body;
	Renderer rend;

	void Start () {
		charge = isPlus ? 1 : -1;
		body = GetComponentInParent<Rigidbody>();
		sviMagneti = FindObjectsOfType<Magnet>().Where(m => m != this && m != bro).ToArray();
		rend = GetComponent<Renderer>();

        body.transform.rotation = Random.rotation;
	}
	
	void Update () {
		Vector3 konacnaSila = Vector3.zero;

		foreach (Magnet m in sviMagneti)
		{
			konacnaSila += Fizika.DirectionalCoulombic((charge, transform.position), (m.charge, m.transform.position));
		}

		body.AddForceAtPosition(konacnaSila, transform.position, ForceMode.Force);

		rend.material.SetFloat("_BaseSpeed", charge * konacnaSila.magnitude);
	}
}


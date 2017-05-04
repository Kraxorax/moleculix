using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;


public class Magnet : MonoBehaviour {

	public bool isPlus = true;

	Vector3 konacnaSila = new Vector3();
	float najUpdTime = 1f;
	float najUpdPassedTime = 0f;
	Magnet[] sviMagneti;
	List<Magnet> najbliziMagneti = new List<Magnet>();
	string id;
	Config config;
	Transform parent;

	void Start () {
		najUpdTime = Random.Range(1f, 2f);
		config = FindObjectOfType<Config>();
		parent = GetComponentInParent<Transform>().GetComponentInParent<Transform>().parent; // WTF?
		sviMagneti = FindObjectsOfType<Magnet>();
		nadjiNajblize();
		//id = Util.CreateId();
	}
	
	void Update () {
		konacnaSila = new Vector3();
		updateNajblizih();

		Util.Log("najblizih: " + najbliziMagneti.Count);

		foreach (Magnet m in najbliziMagneti)
		{
			Vector3 razdaljina = transform.position - m.transform.position;

			Vector3 pravac = razdaljina.normalized;
			Vector3 sila = pravac * ( 1f / razdaljina.magnitude ) * Time.deltaTime * config.Speed;
			
			konacnaSila += isPlus == m.isPlus ? sila : -sila;
		}

		Rigidbody prb = parent.GetComponent<Rigidbody>();
		prb.AddForceAtPosition(konacnaSila, transform.position, ForceMode.Force);
	}

	void updateNajblizih()
	{
		najUpdPassedTime += Time.deltaTime;
		if (najUpdPassedTime > najUpdTime)
		{
			nadjiNajblize();
			najUpdPassedTime = 0;
			najUpdTime = Random.Range(1f, 2f);
		}
	}

	void nadjiNajblize()
	{
		najbliziMagneti.Clear();
		Dictionary<float, Magnet> mapaBlizine = new Dictionary<float, Magnet>();
 		float minKey = 0f;

		foreach (Magnet m in sviMagneti)
		{
			float razdaljina = Mathf.Abs((transform.position - m.transform.position).magnitude);

			if (mapaBlizine.Keys.Count > 0)
			{
				minKey = mapaBlizine.Keys.Min<float>();
			}
			else
			{
				// ostaje 0
			}

			if (razdaljina > minKey)
			{
				mapaBlizine.Add(razdaljina, m);
			}
			bool isFull = mapaBlizine.Count > config.ForceClosest;
			if (isFull)
			{
				mapaBlizine.Remove(minKey);
				minKey = mapaBlizine.Keys.Min<float>();
			}

			//foreach (float key in mapaBlizine.Keys) // neee
			//{
			//	if (razdaljina > minKey)
			//	{
			//		mapaBlizine.Add(razdaljina, m);
			//	}
			//}
			//if (isFull)
			//{
			//	mapaBlizine.Remove(minKey);
			//}


			//if ( !Equals(m) && razdaljina < config.ForceReach )
			//{
			//	najbliziMagneti.Add(m);
			//}

			najbliziMagneti.AddRange( mapaBlizine.Values );

		}
	}

}


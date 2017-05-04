using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Util {
	
	private static bool DoLog = true;

	public static string VecToStr (Vector3 v)
	{
		return "X" + v.x + " Y" + v.y + " Z" + v.z + " Mag" + v.magnitude;
	}

	public static string VecToStr(Vector2 v)
	{
		return "X" + v.x + " Y" + v.y + " Mag" + v.magnitude;
	}

	public static void Log(object msg)
	{
		Log(msg, false);
	}

	public static void Log(object msg, bool doLog)
	{
		if (doLog || DoLog)
		{
			Debug.Log(msg);
		}
	}

	public static string CreateId()
	{
		float seed = Random.Range(Mathf.Pow(10, 10), Mathf.Pow(10, 20));
		string s = seed.ToString();
		if (s.Length > 10)
		{
			s.Remove(0, -10 + s.Length);
		}
		return s;
	}


}
 
using UnityEditor;
using UnityEngine;


namespace Assets.Scripts
{
    public static class Fizika
    {
        public static float Coulombic(float k, (float charge, Vector3 pos) a, (float charge, Vector3  pos) b)
        {
            float force = (k * a.charge * b.charge) / (a.pos - b.pos).magnitude;
            return force;
        }

        public static Vector3 DirectionalCoulombic(float k, (float charge, Vector3 pos) a, (float charge, Vector3 pos) b)
        {
            Vector3 dist = a.pos - b.pos;
            
            float force = (k * a.charge * b.charge) / (dist.sqrMagnitude * 10);

            return dist.normalized * force;
        }

        public static Vector3 DirectionalCoulombic((float charge, Vector3 pos) a, (float charge, Vector3 pos) b)
        {
            return DirectionalCoulombic(1, a, b);
        }
    }
}
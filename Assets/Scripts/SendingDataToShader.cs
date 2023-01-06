using System.Collections;
using UnityEngine;

namespace Assets.Scripts
{
    public class SendingDataToShader : MonoBehaviour
    {
        public enum Sign
        {
            Positive = 1,
            Negative = -1
        }

        public bool isPositive = true;

        Renderer rend;

        // Use this for initialization
        void Start()
        {
            rend = GetComponent<Renderer>();
        }

        // Update is called once per frame
        void Update()
        {
            float speed = isPositive ? Mathf.Sin(Time.time) : 1;
            rend.material.SetFloat("_BaseSpeed", speed);
        }
    }
}
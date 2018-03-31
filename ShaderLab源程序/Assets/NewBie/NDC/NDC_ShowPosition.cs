using UnityEngine;
using System.Collections;

public class NDC_ShowPosition : MonoBehaviour {
    public Rect[] labels;
    public Transform trans;
    public Camera cam;
    Matrix4x4 vp;
    Matrix4x4 vpInverse;
    Vector3 ndcPos;
    Vector3 worldPos;

    void Update () {
       // trans.localToWorldMatrix; //m of mvp
        //��Ϊ���ǽ�ʹ���������������(trans.position),������ȥtrans.localToWorldMatrix����_Object2World
        vp = cam.projectionMatrix * cam.worldToCameraMatrix;//vp of mvp
        //VP������棬���ڰ�һ����-1��1��clip�ռ�ĵ���ת��������ռ���
        vpInverse = vp.inverse;
       // mvp = cam.projectionMatrix* cam.worldToCameraMatrix *trans.localToWorldMatrix;
       ndcPos= vp.MultiplyPoint(trans.position);//��һ����������ĵ�ת����Clip�ռ�
       worldPos = vpInverse.MultiplyPoint(ndcPos);//��һ��Clip�ռ�ĵ�ת������������ռ�
     }
    //ʵ����֤ʱ����Ҫ����piont�����壬�������Ǹ�����Ϊ����ʾ�����ӵ�������
    void OnGUI()
    {
        //��ʾ�������������
        GUI.Label(labels[0], "Point���������� x,y,z " + trans.position.x + "  " + trans.position.y + "  " + trans.position.z);
        //��ʾһ���㾭��MVP����任֮�������
        GUI.Label(labels[1], "Point��NDC���� x,y,z " + ndcPos.x + "  " + ndcPos.y + "  " + ndcPos.z);
        //��ʾһ��Clip�ռ��ڵĵ㱻VP�������ת������������ռ���
        GUI.Label(labels[2], "Clip�䵽World  x,y,z " + worldPos.x + "  " + worldPos.y + "  " + worldPos.z);
    }
}

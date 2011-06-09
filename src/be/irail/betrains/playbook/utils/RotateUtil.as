package be.irail.betrains.playbook.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class RotateUtil
	{
		/**
		 * Rotates a DisplayObject around its center
		 * @param target DisplayObject to rotate around center
		 * @param angleDegrees Angle in degrees
		 */
		public static function rotateAroundCenter(target:DisplayObject, angleDegrees:Number):void {
			var m:Matrix = target.transform.matrix;
			rotateAroundInternalPoint(target, target.width / 2, target.height / 2, angleDegrees);
		}
		
		/**
		 * Rotates a DisplayObject around an inner registration point
		 * @param m current target's transform matrix
		 * @param x rotation registrationpoint x
		 * @param y rotation registrationpoint y
		 * @param angleDegrees - rotation degrees.
		 */
		public static function rotateAroundInternalPoint(target:DisplayObject, x:Number, y:Number, angleDegrees:Number):void {
			var p:Point = target.transform.matrix.transformPoint(new Point(x, y));
			rotateAroundExternalPoint(target, p.x, p.y, angleDegrees);
		}
		
		/**
		 * Rotates a DisplayObject around an external registration point
		 * @param m current target's transform matrix
		 * @param x rotation registrationpoint x
		 * @param y rotation registrationpoint y
		 * @param angleDegrees - rotation degrees.
		 */
		public static function rotateAroundExternalPoint(target:DisplayObject, x:Number, y:Number, angleDegrees:Number):void {
			var m:Matrix = target.transform.matrix;
			m.translate(-x, -y);
			m.rotate(angleDegrees * (Math.PI / 180));
			m.translate(x, y);
			target.transform.matrix = m;
		}
	}
}
package be.irail.betrains.playbook.utils {
	import flash.utils.ByteArray;

	public class SerializeUtil {
		public static function serialize(value:Object):ByteArray {
			var outArray:ByteArray = new ByteArray();
			outArray.writeObject(value);
			outArray.compress();
			return outArray;
		}

		public static function deserialize(value:ByteArray):* {
			value.uncompress();
			return value.readObject();
		}
	}
}
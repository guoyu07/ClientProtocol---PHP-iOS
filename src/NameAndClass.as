package  
{
	import suity.utils.StringUtils;
	/**
	 * ...
	 * @author 不再迟疑
	 */
	public class NameAndClass 
	{
		private var _name:String;
		public var className:String;
		public var url:String;
		public var desc:String;
		public var value:String;
		public var resp:String;
		public var annotation:String;
		public static var varsToClass:Object = new Object();
		public static var varsToFormat:Object = new Object();
		public static function init():void
		{
			varsToClass["boolean"] = "BOOL";
			varsToClass["int"] = "NSInteger";
			varsToClass["int32"] = "NSInteger";
			varsToClass["string"] = "NSString";
			varsToClass["float"] = "CGFloat";
			varsToClass["double"] = "double";
			varsToClass["long"] = "int64_t";
			varsToFormat["boolean"] = "boolValue";
			varsToFormat["int"] = "integerValue";
			varsToFormat["int32"] = "integerValue";
			varsToFormat["float"] = "floatValue";
			varsToFormat["double"] = "doubleValue";
			varsToFormat["long"] = "longLongValue";
			
			varsToClass["ywboolean"] = "BOOL";
			varsToClass["ywint"] = "NSInteger";
			varsToClass["ywint32"] = "NSInteger";
			varsToClass["ywstring"] = "NSString";
			varsToClass["ywfloat"] = "CGFloat";
			varsToClass["ywdouble"] = "double";
			varsToClass["ywlong"] = "int64_t";
			varsToFormat["ywboolean"] = "boolValue";
			varsToFormat["ywint"] = "integerValue";
			varsToFormat["ywint32"] = "integerValue";
			varsToFormat["ywfloat"] = "floatValue";
			varsToFormat["ywdouble"] = "doubleValue";
			varsToFormat["ywlong"] = "longLongValue";
		}
		public function NameAndClass($name:String, $className:String, $url:String,$resp:String, $desc:String, $value:String, $annotation:String) 
		{
			this._name = $name;
			this.className = $className;
			this.url = $url;
			this.desc = $desc;			
			this.value = $value;		
			this.resp = $resp;
			this.annotation = $annotation;	
		}
		public function getBaseClass():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				if (className.substr(className.length-2)=="[]")
				{
					tempName = className.substr(0,className.length-2);
				}else
				{
					tempName = className;
				}
			}else
			{
				tempName = className;
			}
			return tempName;
		}
		public function getClass():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				if (className.substr(className.length-2)=="[]")
				{
					tempName = "NSMutableArray";
				}else
				{
					tempName = className;
				}
			}			
			return tempName;
		}
		public function getStatic():String 
		{
			if (getClass() == "NSString")
			{
				return StringUtils.Format('static NSString *const {0} = @"{1}"', mname, mvalue);
			}else {
				return StringUtils.Format('static NSUInteger const {0} = {1}', mname, mvalue);
			}
		}
		
		public function getInitClass():String 
		{
			var tempName:String = varsToFormat[className.toLocaleLowerCase()];
			if (className.toLocaleLowerCase() == "ywstring")
			{
				tempName = StringUtils.Format('[dic safeValueForKey:@"{0}"]', name);
			}
			else if (!StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = StringUtils.Format('[(NSString *)[dic safeValueForKey:@"{0}"] {1}]', name,tempName);
			}else
			{
				if (getClass() == "NSMutableArray")
				{
					var tempBaseClassName:String = varsToClass[getBaseClass().toLocaleLowerCase()];
					if (StringUtils.IsNullOrEmpty(tempBaseClassName))
					{
						tempName = StringUtils.Format('[{0} array{0}:[dic safeValueForKey:@"{1}"]]', getBaseClass(), name);
					}else 
					{
						tempName = StringUtils.Format('[NSMutableArray safeArrayWithArray:[dic safeValueForKey:@"{0}"]]', name);
					}					
				}else
				{
					tempName = StringUtils.Format('[[{0} alloc] initWithDic:[dic safeValueForKey:@"{1}"]]', getClass(), name);
				}
			}
			return tempName;
		}
		public function getPropertyClass():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (className.toLocaleLowerCase() == "ywstring")
			{
				tempName = StringUtils.Format('@property (copy, nonatomic) NSString *{0}', "m"+topUpName);
			}
			else if (!StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = StringUtils.Format('@property (assign, nonatomic) {0} {1}',tempName, "m"+topUpName);
			}else
			{
				tempName = StringUtils.Format('@property (strong, nonatomic) {0} *{1}',getClass(),"m"+topUpName);
			}
			return tempName;
		}
		
		public function getClassFormate():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = className;
			}
			return tempName;
		}
		
		public function formate():String 
		{
			var tempName:String = varsToClass[className.toLocaleLowerCase()];
			if (StringUtils.IsNullOrEmpty(tempName))
			{
				tempName = className;
			}else
			{
				tempName = "DataFormate";
			}
			return tempName;
		}
		
		public function get name():String 
		{
			var str:String = _name.charAt(0).toLocaleLowerCase();
			str = str + _name.substring(1);
			return str;
		}
		public function get topUpName():String 
		{
			var str:String = _name.charAt(0).toLocaleUpperCase();
			str = str + _name.substring(1);
			return str;
		}
		public function get mname():String 
		{
			return _name.toLocaleUpperCase();
		}
		public function get mvalue():String 
		{
			if (getClass() == "String")
			{
				return '"' + value+'"';
			}else {
				return value;
			}
		}
	}

}
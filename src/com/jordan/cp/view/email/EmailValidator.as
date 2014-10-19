package com.jordan.cp.view.email {
	

	/**
	 * @author jsuntai
	 */
	public class EmailValidator 
	{
		
		//*********************************************************************************************************************************************
		//
		//Wikipedia: "Quoted strings and characters however, are not commonly used. RFC 5321 also warns that "a host
		//that expects to receive mail SHOULD avoid defining mailboxes where the Local-part requires (or uses) the
		//Quoted-string form" (sic)."
		// 
		// Script returns email validation 'false' if the email contains any special characters except ('-','.') reference to the opinion of Wikipedia.
		//
		//**********************************************************************************************************************************************
		
		private static const LOCALPART_SPECIAL_CHARACHTERS_ALLOWED:Boolean = true
		

		private static const LEGAL_CHARS:Array = new Array("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", ".", "+", "_","@")
		private static const DOMAIN_NUMBERS:Array = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
		private static const SPECIAL_CHARS:Array = new Array("!","#","$","%","*","/","?","^","`","{","|","}","~")
		private static const LEGAL_CHARS_NOT_DOUBLED:Array = ["-","."]
		
		
		public function EmailValidator() 
		{
			
		}
		public static function valid(email:String):Boolean
		{
			var localPart:String
			var domainPart:String
			
			if (email.indexOf("@") == -1) { return false } 
			if (email.indexOf("@") != -1) { if (email.charAt(email.indexOf("@")) == email.charAt(email.indexOf("@") + 1)) { return false }}
			if (email.indexOf("@") == 0) { return false }
			if (email.indexOf("@") > email.length - 3) { return false }
			if (email.indexOf("@") != -1) { if (email.indexOf("@") != email.lastIndexOf("@")) {return false }}
			
			for (var i:uint = 0; i < email.length; i++) { if (email.charAt(i) == email.charAt(i + 1)) { if (LEGAL_CHARS_NOT_DOUBLED.indexOf(email.charAt(i)) != -1) { return false }}}
			
			localPart = email.slice(0,email.indexOf("@"))
			domainPart = email.slice(email.indexOf("@") + 1)
			
			if (localPart.length > 64) { return false } 
			if (domainPart.length > 254) { return false } 
				
		
			for (var c:uint = 0; c < SPECIAL_CHARS.length; c++)
			{
				if (localPart.indexOf(SPECIAL_CHARS[c]) != -1)
				{
					return false;
					break;
				}
			}
			for (var x:uint = 0; x < localPart.length; x++)
			{
				if (LEGAL_CHARS.indexOf(localPart.charAt(x)) == -1) { trace("megakasztja!"); return false }
			}
			
			if (localPart.indexOf(" ") != -1) { return false }
			if (localPart.lastIndexOf(".") == localPart.length - 1) { return false }
			if (localPart.indexOf(".") == 0) { return false }
			if (localPart.indexOf(".") != -1) { if (localPart.charAt(localPart.indexOf(".")) == localPart.charAt(localPart.indexOf(".") + 1)) { return false } }
			
			
			for (var a:uint = 0; a < domainPart.length-1; a++)
			{
				if (domainPart.charAt(a) == "-" && domainPart.charAt(a - 1) == ".") { return false }
				if (LEGAL_CHARS.indexOf(domainPart.charAt(a)) == -1) { return false }
				if (domainPart.charAt(a) == "." && domainPart.charAt(a + 2) == "."&& DOMAIN_NUMBERS.indexOf(domainPart.charAt(a+1)) == -1){return false}
			}
			if(email.charAt(email.indexOf("@")+2) == "." && DOMAIN_NUMBERS.indexOf(domainPart.charAt(domainPart.indexOf("@")+1)) == -1){return false}	
			if (domainPart.indexOf(".") == -1) { return false }
			if (domainPart.indexOf(".") == 0) { return false }	
			if (domainPart.indexOf("-") == 0) { return false }
			if (domainPart.lastIndexOf(".") == domainPart.length - 2) { return false }
			if (domainPart.lastIndexOf("-") == domainPart.length - 1) {return false }
			if (domainPart.lastIndexOf(".") > domainPart.length - 3 && DOMAIN_NUMBERS.indexOf(domainPart.charAt(domainPart.lastIndexOf(".")+1)) == -1) {return false }
			if (DOMAIN_NUMBERS.indexOf(domainPart.charAt(domainPart.length - 1)) != -1)
			{
				for (var h:uint = 0; h < domainPart.length; h++){if (domainPart.charAt(h) != "." && DOMAIN_NUMBERS.indexOf(domainPart.charAt(h)) == -1) {return false; break;}}
			}
			return true
		}	
	}
}
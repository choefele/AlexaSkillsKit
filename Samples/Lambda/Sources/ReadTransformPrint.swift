#if os(Linux)
  import Glibc
#else
  import Darwin.C
#endif

/**
 Returns a generator that lets you iterate through a FILE stream one
 line at a time until its end.
 */
fileprivate func lineGenerator(file:UnsafeMutablePointer<FILE>) -> AnyIterator<String>
{
  return AnyIterator { () -> String? in
    var line:UnsafeMutablePointer<CChar>? = nil
    var linecap:Int = 0
    defer { free(line) }
    let ret = getline(&line, &linecap, file)
    
    if ret > 0 {
      guard let line = line else { return nil }
      return String(validatingUTF8: line)
    }
    else {
      return nil
    }
  }
}


/**
 Reads all of stdin in a String buffer. Transforms the string. Prints result to stdout.
 
 */
func readTransformPrint(transform:(String)->String)
{
  var input:String = ""
  for line in lineGenerator(file: stdin) {
    input += line
  }
  let result = transform(input)
  
  print(result, separator: "", terminator: "")
}

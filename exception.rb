class FileNotExistsException < StandardError
  def initialize(msg="File does not exist.", exception_type="file")
    @exception_type = exception_type
    super(msg)
  end
end
class FileNotReadableException < StandardError
  def initialize(msg="File cannot be read.", exception_type="file")
    @exception_type = exception_type
    super(msg)
  end
end
class CodeFormatException < StandardError
end
class ValueFormatException < StandardError
end
class CommentWithoutResultException < StandardError
end
class NoteSerializer
  include JSONAPI::Serializer
  attributes :notes, :is_printable
end

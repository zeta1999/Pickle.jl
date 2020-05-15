module Storage

import Base: setindex!, getindex

@enum DType begin
  FLOAT
  DOUBLE
  HALF
  UINT8
  INT8
  SHORT
  INT
  LONG
  BOOL
end

function jtype(t::DType)
  if t == FLOAT
    return Float32
  elseif t == DOUBLE
    return Float64
  elseif t == HALF
    return Float16
  elseif t == UINT8
    return UInt8
  elseif t == INT8
    return Int8
  elseif t == SHORT
    return Int16
  elseif t == INT
    return Int32
  elseif t == LONG
    return Int64
  elseif t == BOOL
    error("I don't know")
  end
end

function bitwidth(t::DType)
  if t == FLOAT
    return 4
  elseif t == DOUBLE
    return 8
  elseif t == HALF
    return 2
  elseif t == UINT8
    return 1
  elseif t == INT8
    return 1
  elseif t == SHORT
    return 2
  elseif t == INT
    return 4
  elseif t == LONG
    return 8
  elseif t == BOOL
    error("I don't know")
  end
end

function type2dtype(defer)
  type = defer.head
  if type == Symbol("torch.FloatStorage")
    return FLOAT
  elseif type == Symbol("torch.DoubleStorage")
    return DOUBLE
  elseif type == Symbol("torch.HalfStorage")
    return HALF
  elseif type == Symbol("torch.ByteStorage")
    return UINT8
  elseif type == Symbol("torch.CharStorage")
    return INT8
  elseif type == Symbol("torch.ShortStorage")
    return SHORT
  elseif type == Symbol("torch.IntStorage")
    return INT
  elseif type == Symbol("torch.LongStorage")
    return LONG
  elseif type == Symbol("torch.BoolStorage")
    return BOOL
  else
    error("unknown type: $type")
  end
end

struct StorageManager
  data::Dict{String, Tuple{DType, Int, String}}
end

StorageManager() = StorageManager(Dict())
setindex!(sm::StorageManager, value, key) = setindex!(sm.data, value, key)
getindex(sm::StorageManager, key) = getindex(sm.data, key)
const STORAGE = StorageManager()

function persistent_load((id, dtype, key, device, numel, _))
  @assert id == "storage"
  global STORAGE
  setindex!(STORAGE, (type2dtype(dtype), numel, device), key)

  return key
end

end

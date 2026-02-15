//! Core types and includes
#pragma once

#include <base/assert.hpp>
#include <cstdint>
#include <memory>
#include <span>

// these are in the global namespace since most libraries
// won't try defining anything like this in the global namespace
// (and I'd like these types to be used globally a lot more anyways)
using u8 = std::uint8_t;
using i8 = std::int8_t;
using u16 = std::uint16_t;
using i16 = std::int16_t;
using u32 = std::uint32_t;
using i32 = std::int32_t;
using u64 = std::uint64_t;
using i64 = std::int64_t;
using usize = std::size_t;
using isize = std::intptr_t;

namespace util {

	template <class T>
	constexpr void Unused(T t) {
		static_cast<void>(t);
	}

	template <class T>
	using Ref = std::shared_ptr<T>;

	template <class T, class Deleter = std::default_delete<T>>
	using Unique = std::unique_ptr<T, Deleter>;

	template <typename... Ts>
	struct OverloadVisitor : Ts... {
		using Ts::operator()...;
	};

	template <class... Ts>
	OverloadVisitor(Ts...) -> OverloadVisitor<Ts...>;

	template <class T, auto* Free>
	struct UniqueCDeleter {
		constexpr void operator()(T* ptr) {
			if(ptr)
				Free(reinterpret_cast<void*>(ptr));
		}
	};

	/// Use this for wrapping a C-allocated memory block. The defaults here assume
	/// you're wrapping data allocated by malloc(), however, any deallocator pattern
	/// is supported by the UniqueCDeleter.
	template <class T, auto Free = std::free>
	using CUnique = Unique<T, UniqueCDeleter<T, Free>>;

} // namespace util

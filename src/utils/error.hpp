#pragma once
#include <string>
#include <variant>
#include <optional>
#include <format>

namespace util {

	/// An error.
	class Error {
		std::string msg;

		static Error vFormat(const std::string_view formatString, std::format_args args);

	public:
		explicit Error(const std::string& message)
			: msg(message) {}

		template<class ...Args>
		static constexpr auto format(const std::string_view formatString, Args... args) {
			return vFormat(formatString, std::make_format_args(args...));
		}

		/// Formats a system error.
		static Error systemError();

		const char* message() const { return msg.c_str(); }
	};

	/// A type which can store either an error or a value.
	template<class T>
	class ErrorOr {
		std::variant<
			Error,
			T
		> variant;
	public:
		constexpr ErrorOr(const Error& error)
			: variant(error) {}

		constexpr ErrorOr(const T& value)
			: variant(value) {}

		bool isValue() const {
			return std::holds_alternative<T>(variant);
		}

		bool isError() const {
			return std::holds_alternative<Error>(variant);
		}

		const Error& err() const {
			return std::get<Error>(variant);
		}

		T& value() {
			return std::get<T>(variant);
		}

		T& value() const {
			return std::get<T>(variant);
		}
	};

	template<>
	class ErrorOr<void> {
		std::optional<Error> error;
	public:
		ErrorOr() = default;
		ErrorOr(const Error& error)
			: error(error) {}

		bool isError() const {
			return error.has_value();
		}

		const Error& err() const {
			return error.value();
		}
	};

}

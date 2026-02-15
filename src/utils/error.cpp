#include <cstring>
#include <utils/error.hpp>

namespace util {

	Error Error::vFormat(const std::string_view formatString, std::format_args args) {
		return Error(std::vformat(formatString, args));
	}

	Error Error::systemError() {
		char errBuffer[128] {};
		auto* pStr = strerror_r(errno, &errBuffer[0], sizeof(errBuffer));
		return Error::format("System error: {}", std::string_view(pStr));
	}

} // namespace util

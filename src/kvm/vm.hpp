#include <utils/error.hpp>
#include <utils/types.hpp>

namespace kvm {

	class CPU;

	class VM {
		/// The primary vCPU.
		util::Ref<CPU> vcpu;

	   public:
		/// Creates a new VM instance.
		static util::ErrorOr<util::Ref<VM>> create();

		// TODO: more stuff
	};

} // namespace kvm

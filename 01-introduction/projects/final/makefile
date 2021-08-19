PACKAGES := $(wildcard packages/*)
FEATURES := $(wildcard packages/features/*)
BUILD-RUNNER := packages/fav_qs_api packages/key_value_storage
# ALL := $(FEATURES) $(PACKAGES)

print:
	for feature in $(FEATURES); do \
		echo $${feature} ; \
	done
	for package in $(PACKAGES); do \
		echo $${package} ; \
	done


install-dependencies:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		../../../flutterw pub get ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		../../flutterw pub get ; \
		cd ../../ ; \
	done

test:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		../../../flutterw test ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		../../flutterw test ; \
		cd ../../ ; \
	done

test-coverage:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		../../../flutterw test --coverage ; \
		lcov -r coverage/lcov.info "*/__test*__/*" -o coverage/lcov_cleaned.info ; \
		sh ../calculate-min-coverage.sh 100 ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		../../flutterw test --coverage ; \
		lcov -r coverage/lcov.info "*/__test*__/*" -o coverage/lcov_cleaned.info ; \
		sh ../calculate-min-coverage.sh 100 ; \
		cd ../../ ; \
	done

lint:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		../../../flutterw analyze ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		../../flutterw analyze ; \
		cd ../../ ; \
	done
	./flutterw analyze

clean:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		../../../flutterw clean ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		../../flutterw clean ; \
		cd ../../ ; \
	done
	./flutterw clean

build-runner:
	for package in $(BUILD-RUNNER); do \
		cd $${package} ; \
		../../flutterw pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done
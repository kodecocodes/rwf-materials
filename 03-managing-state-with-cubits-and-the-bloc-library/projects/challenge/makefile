PACKAGES := $(wildcard packages/*)
FEATURES := $(wildcard packages/features/*)
BUILD-RUNNER := packages/fav_qs_api packages/key_value_storage

print:
	for feature in $(FEATURES); do \
		echo $${feature} ; \
	done
	for package in $(PACKAGES); do \
		echo $${package} ; \
	done

pods-clean:
	rm -Rf ios/Pods ; \
	rm -Rf ios/.symlinks ; \
	rm -Rf ios/Flutter/Flutter.framework ; \
	rm -Rf ios/Flutter/Flutter.podspec ; \
	rm ios/Podfile ; \
	rm ios/Podfile.lock ; \


get:
	flutter pub get
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		flutter pub get ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		flutter pub get ; \
		cd ../../ ; \
	done

upgrade:
	flutter pub upgrade
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		flutter pub upgrade ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		flutter pub upgrade ; \
		cd ../../ ; \
	done

lint:
	flutter analyze

format:
	flutter format --set-exit-if-changed .

testing:
	flutter test
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		flutter test ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		flutter test ; \
		cd ../../ ; \
	done

test-coverage:
	flutter test --coverage
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		flutter test --coverage ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		flutter test --coverage ; \
		cd ../../ ; \
	done

clean:
	flutter clean
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running clean on $${feature}" ; \
		flutter clean ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running clean on $${package}" ; \
		flutter clean ; \
		cd ../../ ; \
	done

build-runner:
	for package in $(BUILD-RUNNER); do \
		cd $${package} ; \
		echo "Running build-runner on $${package}" ; \
		flutter pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done
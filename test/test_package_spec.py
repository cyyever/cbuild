from src.package_spec import PackageSpecification


def test_package_spec():
    spec = PackageSpecification("opencv[highgui,cudev]:master")
    print(spec)

    assert PackageSpecification.compare_version("v1.1.0", "v1.12.0") < 0
    assert PackageSpecification.compare_version("v2.1.0", "v1.12.0") > 0

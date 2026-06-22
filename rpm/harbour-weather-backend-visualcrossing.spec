Name:       harbour-weather-backend-visualcrossing
Summary:    Visual Crossing weather provider for Sailfish Weather
Version:    1.3.2
Release:    2
License:    BSD-3-Clause
BuildArch:  noarch
URL:        https://github.com/juanro49/harbour-weather-backend-visualcrossing
Source0:    https://github.com/juanro49/%{name}/archive/refs/tags/v%{version}.tar.gz
Requires:   sailfish-components-weather-qt5 >= 1.3.2

%description
This package provides an external weather backend for Sailfish Weather using
the Visual Crossing Timeline API (https://www.visualcrossing.com/).

%prep
%setup -q -n %{name}-%{version}

%build
# Generate the JS translation dictionary from .ts files
python3 scripts/generate_translations.py

%install
# Install the QML backend
mkdir -p %{buildroot}%{_datadir}/sailfish-weather/backends
install -p -m 644 backends/VisualCrossingBackend.qml %{buildroot}%{_datadir}/sailfish-weather/backends/
install -p -m 644 backends/VisualCrossingTranslations.js %{buildroot}%{_datadir}/sailfish-weather/backends/

# Install the icons
mkdir -p %{buildroot}%{_datadir}/themes/sailfish-default/silica/icons-monochrome
install -p -m 644 icons/visual-crossing.png %{buildroot}%{_datadir}/themes/sailfish-default/silica/icons-monochrome/
install -p -m 644 icons/visual-crossing-small.png %{buildroot}%{_datadir}/themes/sailfish-default/silica/icons-monochrome/

%files
%defattr(-,root,root,-)
%license LICENSE
%doc README.md
%{_datadir}/sailfish-weather/backends/VisualCrossingBackend.qml
%{_datadir}/sailfish-weather/backends/VisualCrossingTranslations.js
%{_datadir}/themes/sailfish-default/silica/icons-monochrome/visual-crossing.png
%{_datadir}/themes/sailfish-default/silica/icons-monochrome/visual-crossing-small.png

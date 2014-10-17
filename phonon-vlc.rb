require 'formula'

class PhononVlc <Formula
  homepage 'https://projects.kde.org/projects/kdesupport/phonon/phonon-vlc'
  url "ftp://ftp.kde.org/pub/kde/stable/phonon/phonon-backend-vlc/0.8.0/phonon-backend-vlc-0.8.0.tar.xz"
  sha1 "978f6b15539475e698533b0aeeb988b285a85894"

  head 'git://anongit.kde.org/phonon-vlc'

  depends_on 'cmake' => :build
  depends_on 'xz' => :build
  depends_on 'kde-phonon'
  depends_on 'vlc'
  depends_on 'qt5'

  def install
    #make sure to use the keg-only kde-phonon not the phonon installed with qt
    phonon = Formula.factory("kde-phonon")

    system "cmake . #{std_cmake_parameters} -DPhonon_DIR:PATH=#{phonon.lib}/cmake/phonon -DPHONON_BUILD_PHONON4QT5=ON"
    system "make install"

    # FIXME: Current stable+git phonon4qt5 should install to a different path.
    # phonon is dumb and just loads p lugins blindly from the qt plugin path. we're really sure we want to be loaded, so we delete any other
    # phonon backends first.
    pluginDir = "#{Formula.factory("qt5").prefix}/plugins/phonon_backend"
    print "pluginDir: #{pluginDir} #{Formula.factory('qt5').prefix}"
    system "rm -f #{pluginDir}/*"
    system "cp #{prefix}/lib/kde4/plugins/phonon_backend/phonon_vlc.so #{pluginDir}"
  end

end

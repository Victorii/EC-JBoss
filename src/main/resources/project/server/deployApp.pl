# preamble.pl
$[/myProject/procedure_helpers/preamble]

my $PROJECT_NAME = '$[/myProject/projectName]';
my $PLUGIN_NAME = '@PLUGIN_NAME@';
my $PLUGIN_KEY = '@PLUGIN_KEY@';
use Data::Dumper;

$|=1;

main();


# my $property_path = '/plugins/$pk/project/dryrun';
sub main {
    my $jboss = EC::JBoss->new(
        project_name    =>  $PROJECT_NAME,
        plugin_name     =>  $PLUGIN_NAME,
        plugin_key      =>  $PLUGIN_KEY,
    );
    
    my $params = $jboss->get_params_as_hashref(qw/
        scriptphysicalpath
        warphysicalpath
        appname
        runtimename
        force
        assignservergroups
        assignallservergroups
    /);

    if (!$jboss->{dryrun} && !-e $params->{warphysicalpath}) {
            croak "File: $params->{warphysicalpath} doesn't exists";
    }

    my $command = qq/deploy $params->{warphysicalpath} /;

    if ($params->{appname}) {
        $command .= qq/ --name=$params->{appname} /;
    }

    if ($params->{runtimename}) {
        $command .= qq/ --runtime-name=$params->{runtimename} /;
    }

    if ($params->{force}) {
        $command .= ' --force ';
    }

    if ($params->{assignallservergroups}) {
        $command .= ' --all-server-groups ';
    }
    elsif ($params->{assignservergroups}) {
        $command .= qq/ --server-groups=$params->{assignservergroups}/;
    }

    my %result = $jboss->run_command($command);
    
    if ($result{stdout}) {
        $jboss->out("Command output: $result{stdout}");
    }

    $jboss->process_response(%result);
};
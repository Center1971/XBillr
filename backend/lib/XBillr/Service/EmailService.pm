package XBillr::Service::EmailService;

use strict;
use warnings;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;

sub new {
    my ($class, %args) = @_;
    my $self = {
        smtp_host => $args{smtp_host} || $ENV{SMTP_HOST} || 'localhost',
        smtp_port => $args{smtp_port} || $ENV{SMTP_PORT} || 25,
        smtp_user => $args{smtp_user} || $ENV{SMTP_USER},
        smtp_password => $args{smtp_password} || $ENV{SMTP_PASSWORD},
        smtp_from => $args{smtp_from} || $ENV{SMTP_FROM} || 'noreply@xbillr.local',
        smtp_from_name => $args{smtp_from_name} || $ENV{SMTP_FROM_NAME} || 'XBillr',
    };
    bless $self, $class;
    return $self;
}

sub send_email {
    my ($self, $to, $subject, $body_text, $body_html) = @_;
    
    my $email = Email::Simple->create(
        header => [
            From => sprintf('%s <%s>', $self->{smtp_from_name}, $self->{smtp_from}),
            To => $to,
            Subject => $subject,
            'Content-Type' => $body_html ? 'text/html; charset=UTF-8' : 'text/plain; charset=UTF-8',
        ],
        body => $body_html || $body_text,
    );
    
    eval {
        sendmail($email, {
            host => $self->{smtp_host},
            port => $self->{smtp_port},
            username => $self->{smtp_user},
            password => $self->{smtp_password},
        });
    };
    
    if ($@) {
        return { success => 0, error => $@ };
    }
    
    return { success => 1 };
}

sub send_login_credentials {
    my ($self, $user, $password, $login_url) = @_;
    
    $login_url ||= $ENV{APP_URL} || 'http://localhost:3000';
    
    my $subject = 'Ihre XBillr Login-Daten';
    my $body_html = <<"HTML";
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background-color: #f9f9f9; }
        .credentials { background-color: white; padding: 15px; margin: 20px 0; border-left: 4px solid #4CAF50; }
        .button { display: inline-block; padding: 12px 24px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; margin-top: 20px; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
        .warning { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Willkommen bei XBillr</h1>
        </div>
        <div class="content">
            <p>Hallo ${\$user->first_name || $user->username},</p>
            <p>Ihr Benutzerkonto wurde erstellt. Hier sind Ihre Login-Daten:</p>
            
            <div class="credentials">
                <p><strong>Benutzername:</strong> ${\$user->username}</p>
                <p><strong>E-Mail:</strong> ${\$user->email}</p>
                <p><strong>Passwort:</strong> $password</p>
            </div>
            
            <p>Sie können sich jetzt unter folgender Adresse anmelden:</p>
            <p><a href="$login_url" class="button">Zur Anmeldung</a></p>
            
            <div class="warning">
                <strong>⚠️ Wichtig:</strong> Bitte ändern Sie Ihr Passwort nach dem ersten Login aus Sicherheitsgründen.
            </div>
            
            <p>Bei Fragen stehen wir Ihnen gerne zur Verfügung.</p>
        </div>
        <div class="footer">
            <p>Mit freundlichen Grüßen<br>Ihr XBillr Team</p>
        </div>
    </div>
</body>
</html>
HTML

    my $body_text = <<"TEXT";
Willkommen bei XBillr

Hallo ${\$user->first_name || $user->username},

Ihr Benutzerkonto wurde erstellt. Hier sind Ihre Login-Daten:

Benutzername: ${\$user->username}
E-Mail: ${\$user->email}
Passwort: $password

Sie können sich jetzt unter folgender Adresse anmelden:
$login_url

WICHTIG: Bitte ändern Sie Ihr Passwort nach dem ersten Login aus Sicherheitsgründen.

Bei Fragen stehen wir Ihnen gerne zur Verfügung.

Mit freundlichen Grüßen
Ihr XBillr Team
TEXT

    return $self->send_email($user->email, $subject, $body_text, $body_html);
}

sub send_password_reset {
    my ($self, $user, $reset_token, $reset_url) = @_;
    
    $reset_url ||= ($ENV{APP_URL} || 'http://localhost:3000') . '/reset-password?token=' . $reset_token;
    
    my $subject = 'Passwort zurücksetzen - XBillr';
    my $body_html = <<"HTML";
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #2196F3; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background-color: #f9f9f9; }
        .button { display: inline-block; padding: 12px 24px; background-color: #2196F3; color: white; text-decoration: none; border-radius: 4px; margin-top: 20px; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
        .warning { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Passwort zurücksetzen</h1>
        </div>
        <div class="content">
            <p>Hallo ${\$user->first_name || $user->username},</p>
            <p>Sie haben eine Passwort-Zurücksetzung angefordert. Klicken Sie auf den folgenden Link, um Ihr Passwort zurückzusetzen:</p>
            
            <p><a href="$reset_url" class="button">Passwort zurücksetzen</a></p>
            
            <p>Oder kopieren Sie diesen Link in Ihren Browser:</p>
            <p style="word-break: break-all;">$reset_url</p>
            
            <div class="warning">
                <strong>⚠️ Wichtig:</strong> Dieser Link ist 24 Stunden gültig. Wenn Sie keine Passwort-Zurücksetzung angefordert haben, ignorieren Sie diese E-Mail.
            </div>
        </div>
        <div class="footer">
            <p>Mit freundlichen Grüßen<br>Ihr XBillr Team</p>
        </div>
    </div>
</body>
</html>
HTML

    my $body_text = <<"TEXT";
Passwort zurücksetzen - XBillr

Hallo ${\$user->first_name || $user->username},

Sie haben eine Passwort-Zurücksetzung angefordert. Klicken Sie auf den folgenden Link, um Ihr Passwort zurückzusetzen:

$reset_url

WICHTIG: Dieser Link ist 24 Stunden gültig. Wenn Sie keine Passwort-Zurücksetzung angefordert haben, ignorieren Sie diese E-Mail.

Mit freundlichen Grüßen
Ihr XBillr Team
TEXT

    return $self->send_email($user->email, $subject, $body_text, $body_html);
}

1;

